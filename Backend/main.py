import os
import json
from typing import List
from uagents import bureau

from fastapi import FastAPI
from openai import OpenAI
import google.generativeai as genai
from uagents import Agent, Context, Model, Protocol

# from json_tools import extract_json,validate_json_with_model,model_to_json,json_to_pydantic

app = FastAPI()

client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
language_model = "gpt-4-turbo-preview"

agent = Agent(name="agent")
proto = Protocol()

genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))
model = genai.GenerativeModel(
    "gemini-1.5-pro-latest",
    generation_config={"response_mime_type": "application/json"},
)


def model_to_json(model_instance):
    """
    Converts a Pydantic model instance to a JSON string.

    Args:
        model_instance (YourModel): An instance of your Pydantic model.

    Returns:
        str: A JSON string representation of the model.
    """
    return model_instance.model_dump_json()


class Story:
    user_history: str


class Action(Model):
    action: str


class UserAction(Model):
    action: str
    money: float


class StoryDataModel(Model):
    story: str
    options: List[UserAction]


class ResultFromAction(Model):
    result: str


class StoryAndResponse(Model):
    story: str
    response: str


class Story(Model):
    user_history: str


class Action(Model):
    action: str


class BasePrompt(Model):
    story_bp: str
    result_bp: str


example_story_model = StoryDataModel(
    story="You have a dog named Riker, and Riker is very happy and going to a clothing store. He sees many different options, but not sure what to choose. Which one would be best.",
    options=[
        UserAction(action="Action 1", money=10.0),
        UserAction(action="Action 2", money=20.0),
        UserAction(action="Action 3", money=30.0),
        UserAction(action="Action 4", money=40.0),
    ],
)


@agent.on_event("startup")
async def startup(sender: str, ctx: Context):
    example_result_model = ResultFromAction(
        result="Riker chooses to buy a new shirt and is very happy with his choice. He then goes to the park to show off his new shirt."
    )

    story_base_prompt = f"You are given the current story history. Generate a new story, followed by 4 multiple choice Responses of what could happen next and the amount of money each action would cost. Please do so using this JSON schema: {model_to_json(example_story_model)}"
    result_base_prompt = f"Given the story and the user's choice, generate the result of the user's choice. Please do so using this JSON schema: {model_to_json(example_result_model)}"
    ctx.context.storage.set("story_bp", story_base_prompt)
    ctx.context.storage.set("result_bp", result_base_prompt)
    ctx.context.send(
        sender, BasePrompt(story_base_prompt, result_base_prompt)
    )  # Get History from frontend and send it as a parameter and store it in history


@proto.on_message(model=BasePrompt, replies={StoryAndResponse})
@app.post("/api/get_story", response_model=None)
def get_story(ctx: Context, story: Story, sender: str):
    try:
        prompt = (
            ctx.context.storage.get("story_bp")
            + "\n\n"
            + "Current Story History:"
            + "\n"
            + story.user_history
        )
        response = model.generate_content(prompt)
        print(response.text)
        ctx.context.storage.set("story", story)
        ctx.context.storage.set("resp", response.text)
        ctx.context.send(sender, StoryAndResponse(story=story, response=response.text))
        return json.loads(response.text)

    except Exception as ex:
        print(f"error: An error occurred while generating the story in get_story. {ex}")
        return {
            f"error": "An error occurred while generating the story in get_story: {ex}"
        }


@proto.on_message(StoryAndResponse)
@app.post("/api/get_result", response_model=None)
def get_result(story: Story, action: Action, ctx: Context):
    try:
        prompt = (
            ctx.context.storage.get("result_bp")
            + "\n\n"
            + "Current Story:"
            + "\n"
            + story.user_history
            + "\n\n"
            + "User's Choice:"
            + "\n"
            + action.action
        )
        response = model.generate_content(prompt)
        print(response.text)

        return json.loads(response.text)
    except Exception as ex:
        print(
            f"error: An error occurred while generating the user action result in get_result. {ex}"
        )
        return {
            f"error": "An error occurred while generating the user action result in get_result: {ex}"
        }


@app.get("/api/gpt_json_response_example")
async def gpt_json_response_example(
    text: str,
):  # you can also make this into a text: [str] in order to accept multiple role and contents.
    """
    EXAMPLE DESCRIPTION

    Args:
        EXAMPLE ARGUMENTS

    Returns:
        EXAMPLE RETURN
    """

    try:
        summary_complete = client.chat.completions.create(
            model=language_model,
            response_format={
                "type": "json_object"
            },  # remove this to get a text response rather than JSON
            # feel free to change the messages array to whatever you like
            messages=[
                {
                    "role": "system",
                    "content": (
                        "You are a helpful language tutor and annotator designed to output JSON with the following schema:\n"
                        "{\n"
                        '  "Title": "A string summarizing the correlation and suggestion for what to do given this summary information.",\n'
                        '  "Content": "A string explaining the correlation number provided. Make sure to list out the names of the things we are comparing and the correlation between them in the response. Then please also provide a suggestion as to what you can do with this information. Keep it concise and address the user directly instead of speaking in third person.\n'
                        "}\n"
                        "Using the correlation between the two data sets, provide a summary of the relationship between the two data sets by following the schema. The summary should include the strength and direction of the relationship, as well as any potential implications for the user's health. If the correlation is not significant, provide a brief explanation of the result. If the correlation is significant, provide a brief explanation of the result. The summary should be written in clear, concise language and should be suitable for a general audience. Please limit the content response to 4 sentences max, and do not mention the term 'data sets' in your resopnse.\n"
                        "An example of a title is: 'Holistic Approach to Enhancing Your Gaming Skills'\n"
                        "An example of a summary for a significant correlation might be: 'The correlation between heart rate and oxygen saturation is 0.8, indicating a strong positive relationship. This suggests that as heart rate increases, oxygen saturation also increases. This could indicate that you are exercising or experiencing stress. If you are not exercising or experiencing stress, this could be a sign of a health issue and they should consult a doctor.'\n"
                        "Another example of a summary is: 'Our comprehensive analysis has revealed a nuanced correlation between heart rate and field of view VPI score with a score of .69, indicating a subtle relationship that suggests other elements may play a more pivotal role in gaming performance. The correlation underscores the minimal impact of physical excitement on game outcomes, directing attention towards broader factors such as strategy development, environmental adjustments, and dedicated practice sessions for improvement.'\n"
                        "A final example of a summary is: 'The correlation between heart rate and overall VPI score is -0.64, indicating a moderate negative relationship. This suggests that as heart rate increases, overall VPI score tends to decrease. This could be indicative of performance declines under stress or physical exertion. Considering this, focusing on stress management and maintaining calm could potentially improve your VPI scores.'\n"
                        "If you cannot provide a summary, return a JSON with a title of 'No Summary Availiable' and the content explaining why."
                    ),
                },
                {"role": "user", "content": (text)},
            ],
        )

        return json.loads(summary_complete.choices[0].message.content)
    except Exception as _:
        return {"error": "An error occurred while generating a correlation summary."}


agent.include(proto)
